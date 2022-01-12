class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    def home
        name = params["name"] || "World"
        age = params["age"] || 23
        render "application/home", locals: { name: name, :age=> age}
    end

    def create_post
        post = Post.new("title"=>params["title"], 
                        "body"=>params["body"],
                        "author"=>params["author"])
        if post.save
            redirect_to '/list_post'
        else 
            render 'application/new_post', locals: { post: post }
        end
    end

    def new_post
        post = Post.new
        render "application/new_post", locals: {post: post}
    end

    def list_post
        posts = connection.execute "select * from posts"
        render "application/posts", locals: {posts: posts}
    end

    # def show_post
    #     post = Post.find(params["id"])
    #     comments = connection.execute("SELECT * FROM comments WHERE comments.post_id = ?", params['id'])
    #     render "application/show_post", locals: {post: post, comments: comments}
    # end

    def update_post
        post = Post.find(params['id'])
        post.set_attributes('title' => params['title'], 'body' => params['body'],
          'author' => params['author'])
        if post.save
          redirect_to '/list_posts'
        else
          render 'application/edit_post', locals: { post: post }
        end
    end

    def edit_post
        post = Post.find(params["id"])
        render "application/edit_post", locals: {post: post}
    end

    def show_post
        post = Post.find(params['id'])
        comment = Comment.new
        comments = post.comments(params["id"])
        render "application/show_post/",
          locals: { post: post, comment: comment, comments: comments }
    end

    def create_comment

        insert_comment_query = <<-SQL
          INSERT INTO comments (body, author, post_id, created_at)
          VALUES (?, ?, ?, ?)
        SQL
    
        connection.execute insert_comment_query,
          params['body'],
          params['author'],
          params['post_id'],
          Date.current.to_s
    
          redirect_to "/list_post/#{params['post_id']}"
    end

    def delete_comment
        post = Post.find(params['post_id'])
        post.delete_comment(params['comment_id'])
        redirect_to "/list_post/#{params['post_id']}"
    end

    def list_comments
        comments = Comment.all
    
        render 'application/list_comments', locals: { comments: comments }
    end

    def destroy
        post = Post.find(params["id"]) 
        connection.execute "DELETE FROM posts where id= ?", params["id"]
        redirect_to "/list_post"
    end

    def create_comment
        post     = Post.find(params['post_id'])
        comments = post.comments(params['post_id'])
        # post.build_comment to set the post_id
        comment  = post.build_comment('body' => params['body'], 'author' => params['author'])
        if comment.save
          # redirect for success
          redirect_to "/list_post/#{params['post_id']}"
        else
          # render form again with errors for failure
          render 'application/show_post',
            locals: { post: post, comment: comment, comments: comments }
        end
    end
    
    private
    def connection
        db_connection = SQLite3::Database.new "db/development.sqlite3"
        db_connection.results_as_hash = true
        db_connection
    end
end
