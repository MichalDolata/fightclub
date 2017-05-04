class Match < ApplicationRecord
  belongs_to :next_match, class_name: 'Match', optional: true
  belongs_to :home, class_name: 'Team', optional: true
  belongs_to :away, class_name: 'Team', optional: true
  belongs_to :tournament

  has_many :results

  enum status: [ :draft, :active, :closed, :conflict]
  enum next_match_type: [ :home, :away ]

  def close
    winner = pick_winner
    if winner
      closed!
      unless next_match.nil?
        next_match[next_match_type + '_id'] = winner.id
        next_match.status = 'active' unless next_match.home.nil? || next_match.away.nil?
        next_match.save
      end
      true
    end
  end

  def pick_winner
    if home_score > away_score
      home
    elsif home_score < away_score
      away
    else
      false
    end
  end

  def free_seed?
    home_score == 2 && away.nil?
  end

  def final?
    next_match.nil?
  end
end
