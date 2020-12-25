# frozen_string_literal: true

# == Schema Information
#
# Table name: github_ignores
#
#  path       :string           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_ignores_on_path  (path) UNIQUE
#
class GithubIgnore < ApplicationRecord
  self.primary_key = :path

  def self.track!(path)
    find_or_create_by! path: path
  end

  def self.ignored?(path)
    !where(path: path).count.zero?
  end

  def self.expire!(timeframe: 14.days)
    where("created_at < ?", timeframe.ago).destroy_all
  end
end
