﻿class Game < ActiveRecord::Base
  attr_accessible :area, :author, :coments, :date, :equipment, :legend, :name, :current, :finished_at

  has_many :tasks
  has_many :tryes
  has_many :teams
  has_many :task_orders
  has_many :rgames
  
    validates :name, uniqueness: { message: "Такое название уже есть" }, presence: { message: "Вы не ввели название" }
	validates :author, presence: { message: "Вы не ввели автора" }
    validates :legend, presence: { message: "Как же без легенды-то?" }

  validate :game_starts_in_the_future

  scope :finished, :conditions => ['finished_at IS NOT NULL']

  def started?
    self.date.nil? ? false : Time.now > self.date
  end

  def finish_game!
    self.finished_at = Time.now
    self.save!
  end

  def finished?
    !self.finished_at.nil?
  end

protected

  def game_starts_in_the_future
    if self.finished_at.nil? and self.date and self.date < Time.now
      self.errors.add(:date, "Вы выбрали дату из прошлого. Так нельзя :-)")
    end
  end
  
end
