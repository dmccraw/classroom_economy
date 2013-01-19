# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  username               :string(255)      not null
#  user_type              :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # remove validatable from devise and roll my own
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_format_of :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of   :password, :on=>:create
  validates_confirmation_of   :password, :on=>:create
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :user_type, :username, :login, :time_zone

  # relationships
  # has_many :groups, through: :memberships
  has_many :accounts, as: :owner, dependent: :destroy
  has_many :stores, through: :store_owners
  has_many :store_owners, dependent: :destroy
  has_many :store_managers, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :job_assignments
  has_many :groups, through: :memberships
  # has_many :transactions

  # validations
  validates :user_type, presence: true
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :email_for_admin_teacher

  # callbacks
  before_validation :generate_username

  USER_TYPE_STUDENT = 1
  USER_TYPE_TEACHER = 2
  USER_TYPE_ADMIN   = 10

  # scope
  scope :admins, where(user_type: USER_TYPE_ADMIN)
  scope :teachers, where(user_type: USER_TYPE_TEACHER)
  scope :students, where(user_type: USER_TYPE_STUDENT)

  attr_accessor :login

  def student?
    self.user_type == USER_TYPE_STUDENT
  end

  def admin?
    self.user_type == USER_TYPE_ADMIN
  end

  def teacher?
    self.user_type == USER_TYPE_TEACHER
  end

  def display_name
    "#{self.first_name} #{self.last_name}"
  end

  def in_group_with?(user)
# Rails.logger.red(user.inspect)
    user.groups.each do |user_group|
Rails.logger.red(user.inspect)
      self.groups.each do |group|
Rails.logger.red(group.inspect)
        return true if group.id == user_group.id
        return true if group.user_id == self.id
      end
    end
    false
  end

  def in_group?(group_id)
    groups.each do |group|
      return true if group_id == group.id
    end
    return false
  end

  def display_user_type
    case self.user_type
    when USER_TYPE_TEACHER
      "teacher"
    when USER_TYPE_ADMIN
      "admin"
    when USER_TYPE_STUDENT
      "student"
    end
  end

  def groups
    case user_type
    when USER_TYPE_TEACHER
      Group.find_all_by_user_id(self.id)
    when USER_TYPE_ADMIN
      Group.all
    when USER_TYPE_STUDENT
      _groups = []
      # find groups through memberships
      memberships.each do |membership|
        _groups << membership.group
      end
      _groups
    end
  end

  # def in_group?(group)
  #   return true if group.user_id == self.id
  #   groups.each do |_group|
  #     if group.id == _group.id
  #       return true
  #     end
  #   end
  #   false
  # end

  def owns_or_manages_accounts(group)
    account_ids = [account(group).id]
    account_ids += store_owners.map {|so| so.store.account.id }
    account_ids += store_managers.map {|so| so.store.account.id }
    account_ids
  end

  def owns_or_manages_account?(account)
    return true if account.owner_id == self.id && account.owner_type == self.class.to_s

    if account.store?
      store_owners.each do |store_owner|
        return true if account.owner_id == self.id
      end
      store_managers.each do |store_manager|
        return true if store_manager.store.account.id == account.id
      end
    end
    false
  end

  def account(group_id)
    Account.where(owner_id: self.id, owner_type: self.class.to_s, group_id: group_id).first
  end

  # devise login with username or email
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

private

  def generate_username
    if self.username.blank?
      return false if self.first_name.blank?|| self.last_name.blank?
      uname = "#{self.first_name[0]}#{self.last_name}".downcase
      count = 1
      while user = User.find_by_username(uname)
        uname = "#{self.first_name[0]}#{self.last_name}_#{count}".downcase
        count += 1
      end
      self.username = uname
    end
  end

  def email_for_admin_teacher
    unless student?
      if email.blank?
        errors.add(:email, "Email can't be blank.")
      end
    end
  end

end
