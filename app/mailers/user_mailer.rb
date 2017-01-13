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

    def mod_delete(reason,email,title,subreddit)
      @reason=reason
      @email=email
      @title=title
      @subreddit=subreddit
      mail(to:@email,subject:'Mod Deleted your post')
    end

    def comment_mod_delete(reason,email,title)
      @reason=reason
      @email=email
      @title=title
      mail(to:@email,subject:'Mod Deleted your post')
    end

end
