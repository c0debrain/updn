class UsersController < ApplicationController
  def show
    @showing_user = User.where(:username => params[:id]).first!
    @title = "User #{@showing_user.username}"
  end

  def tree
    @title = "Users"

    parents = {}
    User.all.each do |u|
      (parents[u.invited_by_user_id.to_i] ||= []).push u
    end

    @tree = []
    recursor = lambda{|user,level|
      if user
        @tree.push({
          :level => level,
          :user_id => user.id,
          :username => user.username,
          :karma => user.karma,
          :is_moderator => user.is_moderator?,
          :is_admin => user.is_admin?,
          :created => user.created_at,
        })
      end

      # for each user that was invited by this one, recurse with it
      (parents[user ? user.id : 0] || []).each do |child|
        recursor.call(child, level + 1)
      end
    }
    recursor.call(nil, 0)

    @tree
  end

  def invite
    @title = "Pass Along an Invitation"
  end
end
