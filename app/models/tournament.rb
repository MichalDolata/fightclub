class Tournament < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :teams
  has_many :matches, -> { includes :next_match, :home, :away }

  enum status: [ :signup_mode, :active, :finished ]

  validates :name, presence: true, length: { in: 3..64 }
  validates :teams_count,
            inclusion: { in: 2..1024, message: 'is not in range <2; 1024>' },
            power_of_two: true

  def rounds
    Math.log2(teams_count).round
  end

  def generate_bracket
    self.matches.clear # TODO: delete if tested

    shuffle_seeds
    initialize_bracket_generator
    generate_matches

    active!
  end

  def close
    update(status: :finished)
  end

  def winner
    matches.find_by(round_id: rounds - 1).pick_winner
  end

  private
    def shuffle_seeds
      @teams = self.teams.shuffle
    end

    def initialize_bracket_generator
      matches_count = teams_count - 1
      @first_round_matches_count = teams_count / 2
      @rounds = rounds
      @current_round = 0
      @current_match_id = 0

      @matches = []

      matches_count.times { @matches << { } }
      @matches = self.matches.build(@matches)
    end

    def generate_first_round
      full_pairs = teams.length - @first_round_matches_count
      free_pairs = @first_round_matches_count - full_pairs
      team_id = 0

      full_pairs.times do
        @matches[@current_match_id].update_attributes({ round_id: @current_round, home: @teams[team_id],
                          away: @teams[team_id + 1], next_match: @matches[@first_round_matches_count + @current_match_id / 2],
                          next_match_type: @current_match_id % 2, status: 'active'
                        })
        @current_match_id += 1
        team_id += 2
      end


      free_pairs.times do
        @matches[@current_match_id].update_attributes({ round_id: @current_round, home: @teams[team_id], away: nil,
                          home_score: 2, away_score: 0, next_match: @matches[@first_round_matches_count + @current_match_id / 2],
                          next_match_type: @current_match_id % 2
                        })
        @matches[@current_match_id].close
        @current_match_id += 1
        team_id += 1
      end
    end

    def generate_matches
      generate_first_round

      # create matches in others rounds
      @current_round = 1
      next_match_id = @first_round_matches_count * 1.5
      (rounds - 1).downto(1) do |round|
        puts "Round #{round} #{2 ** (round - 1)}"
        matches_in_round = 2 ** (round - 1)
        matches_in_round.times do |m|
          status = @matches[@current_match_id].home.nil? || @matches[@current_match_id].away.nil? ? 'draft' : 'active'

          @matches[@current_match_id].update_attributes({ round_id: @current_round, next_match: @matches[next_match_id],
                                           next_match_type: m % 2, status: status})
          @current_match_id += 1
          if m % 2 == 1
            next_match_id +=1
          end
        end
        @current_round += 1
      end

      @matches.each(&:save)
    end
end