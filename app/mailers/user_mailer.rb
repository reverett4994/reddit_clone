class UserMailer < ApplicationMailer
    default from: 'reddit_clone.com'

    def welcome(user)
      @user=user
      mail(to:@user.email,subject:'Welcome!')
    end

    def goodbye(user)
      @user=user
      mail(to:@user.email,subject:'Goodbye :(')
    end

    def new_comment(comment)
      @comment=comment
      @post=Post.find(@comment.commentable_id)
      mail(to:@post.user.email,subject:'New Comment')
    end

end
