class Report < ApplicationRecord
  # relationships
  belongs_to :user
  has_many :meeting_topics, dependent: :destroy
  has_many :meeting_challenges, dependent: :destroy

  # validations
  validates :title, :content, :number_of_attendees, :user_id, presence: true

  accepts_nested_attributes_for :meeting_topics,
									reject_if: proc { |attributes| attributes['topic'].blank? },
									allow_destroy: true

  accepts_nested_attributes_for :meeting_challenges,
									reject_if: proc { |attributes| attributes['challenge'].blank? },
                  reject_if: proc { |attributes| attributes['requires_attention'].blank? },
									allow_destroy: true
end
