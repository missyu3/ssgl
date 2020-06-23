class ChallengeStart < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :assign
  belongs_to :task
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :feed_backs, dependent: :destroy

  enum status: { complete: 0 , underway: 1 , awaiting_review: 2, remand: 3}

  private
  scope :create_challenge_start, -> (task: task, deadline: "", user: current_user) do
    next if task.nil?
    task = Task.find(task)
    user = user
    team = Team.find(task.team_id)
    assign = Assign.find(task.assign_id)
    create(status: :underway,
           deadline: "",
           user_id: user.id,
           team_id: team.id,
           assign_id: assign.id,
           task_id: task.id)
  end

  scope :complete_challenge_start, ->  do
    update(status: :complete)
  end

  scope :find_challenge_start, -> (task: task) do
    next if task.nil?
    ChallengeStart.find_by(task_id: task)
  end

  scope :get_ansers, -> (user: user) do
    where(user_id: user.id)
  end

  scope :with_challenge_start_name, -> (name) do
    next if name.nil?
    where(user_id: User.where("name LIKE ?", "%#{name}%").select("id"))
  end
  scope :with_challenge_start_status, -> (status) do
    next if status.nil? || status.blank?
    where(status: status)
  end
end
