# frozen_string_literal: true

# == Schema Information
#
# Table name: rubygem_download_stats
#
#  id                    :bigint           not null, primary key
#  absolute_change_month :integer
#  date                  :date             not null
#  growth_change_month   :decimal(, )
#  relative_change_month :decimal(, )
#  rubygem_name          :string           not null
#  total_downloads       :integer          not null
#
# Indexes
#
#  index_rubygem_download_stats_on_rubygem_name_and_date  (rubygem_name,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (rubygem_name => rubygems.name)
#
class Rubygem::DownloadStat < ApplicationRecord
  belongs_to :rubygem,
             primary_key: :name,
             foreign_key: :rubygem_name,
             inverse_of:  :download_stats

  has_one :project, through: :rubygem

  has_many :trends, class_name:  "Rubygem::Trend",
                    foreign_key: :rubygem_download_stat_id,
                    inverse_of:  :rubygem_download_stat,
                    dependent:   :destroy

  def self.monthly(base_date: Rubygem::DownloadStat.maximum(:date))
    where("(#{table_name}.date <= ?)", base_date)
      .where("(#{table_name}.date - ?) % 28 = 0", base_date)
  end

  def self.with_associations
    includes(:rubygem, :project)
      .joins(:rubygem, :project)
  end
end
