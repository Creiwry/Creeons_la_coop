# frozen_string_literal: true

# == Schema Information
#
# Table name: members_missions
#
#  member_id  :bigint(8)        not null
#  mission_id :bigint(8)        not null
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#

class MembersMission < ApplicationRecord
  belongs_to :member
  belongs_to :mission
end
