class Post
    attr_reader :id, :title, :body, :author, :created_at, :errors

    def initialize(attributes={})
        @id = attributes["id"]
        @title = attributes["title"]
        @body = attributes["body"]
        @author = attributes["author"]
        @created_at = attributes["created_at"]
        @errors = {}
        set_attributes(attributes)
    end

    def build_comment(attributes)
        Comment.new(attributes.merge!('post_id' => id))
    end
    
    def create_comment(attributes)
        comment = build_comment(attributes)
        comment.save
    end

    def new_record?
        id.nil?
    end

    def delete_comment(comment_id)
        Comment.find(comment_id).destroy
    end

    def comments(id)
        comment_hashes = (connection.execute 'SELECT * FROM comments WHERE comments.post_id = ?', id)
        comment_hashes.map do |comment_hash|
          Comment.new(comment_hash)
        end
    end

    def save
        return false unless valid?

        insert_query = <<-SQL
        INSERT INTO posts (title, body, author, created_at)
        VALUES (?, ?, ?, ?)
      SQL
        
      connection.execute insert_query,
        title,
        body,
        author,
        Date.current.to_s
  
    end
    
    def self.find(id)
        hash_post = connection.execute("SELECT * FROM posts WHERE id= ? LIMIT 1", id).first
        Post.new(hash_post)
    end

    def create_comment(attributes)
        comment = Comment.new(attributes.merge!('post_id' => id))
        comment.save
    end

    def self.connection
        db_connection = SQLite3::Database.new "db/development.sqlite3"
        db_connection.results_as_hash = true
        db_connection
    end
    def valid?
        !title.to_s.empty? && !body.to_s.empty? && !author.to_s.empty?
    end
    def error_valid?
        @errors["title"] = "Title can't be blank" if @title.blank?
        @errors["author"] = "author can't be blank" if @author.blank?
        @errors["body"] = "body can't be blank" if @body.blank?
        @errors.empty?
    end

    def set_attributes(attributes)
        @id = attributes['id'] if new_record?
        @title = attributes['title']
        @body = attributes['body']
        @author = attributes['author']
        @created_at ||= attributes['created_at']
    end

    def connection
        self.class.connection
    end

end