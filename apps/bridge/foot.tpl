<hr />

% notices_handler
% # XXX should post to bridge_post or similar
<form action="" method="post">
    <textarea name="comment_text" id="comment_text" cols="80" rows="16">%($"saved_comment_text%)</textarea>
    <br />
    <input type="hidden" name="document_uri" value="%($req_path%)" />
    <input type="submit" name="post_comment" value="Post a comment" />

% if(~ $#logged_user 0 && ! ~ $#allow_new_user_comments 0) {
    <label>New user name:
        <input type="text" name="comment_user" value="%($"post_arg_comment_user%)" />
    </label>

    <label>Password:
        <input type="password" name="comment_passwd" value="" />
    </label>

    <label>Repeat password:
        <input type="password" name="comment_passwd2" value="" />
    </label>
    <div style="font-size: 70%">
    Enter your desired user name/password and after your comment has been reviewed by an addmin it will be posted and your account will be enabled. If you are already registered please <a href="/_users/login">login</a> before posting.
    </div>
% }
</form>
