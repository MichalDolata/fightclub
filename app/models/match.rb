class Match < ApplicationRecord
  belongs_to :next_match, class_name: 'Match', optional: true
  belongs_to :home, class_name: 'Team', optional: true
  belongs_to :away, class_name: 'Team', optional: true
  belongs_to :tournament
end
