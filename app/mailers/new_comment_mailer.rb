class NewCommentMailer < ActionMailer::Base
  default from: "pmtoolsinfo@gmail.com"
  def notify_owner comment
    @comment = comment
    @discussion= comment.commentable  
    @receiver=@discussion.user.email
    @proj=@discussion.project
    mail(to: @receiver,subject: "Discussion #{@discussion.id} has a new comment from #{comment.user.email}")
  end
end
