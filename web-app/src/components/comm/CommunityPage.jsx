import React, { useState, useEffect, useContext } from 'react';
import { getAISuggestions } from '../utils/aiServices';
import PageContext from "../page/PageContext";
import styles from './Community.module.css';
import newmage from "../../assets/images/baby.jpg"

const CommunityPage = () => {
  const [posts, setPosts] = useState([]);
  const [newPost, setNewPost] = useState({ title: '', content: '' });
  const ctx = useContext(PageContext);
  const { changePage } = ctx;

  useEffect(() => {
    setPosts([
      {
        id: 1,
        userId: 1,
        title: "I Need Help with My Baby’s Sleep Schedule",
        content: "I’m struggling to get my baby to sleep through the night. Any tips?",
        comments: [{ userId: 2, comment: "Try establishing a bedtime routine and keep the room dark!" }],
        likes: 5,
        retweets: 3,
      },
      {
        id: 2,
        userId: 1,
        title: "Best Foods During Pregnancy",
        content: "What are some foods that helped you during pregnancy?",
        comments: [],
        likes: 2,
        retweets: 1,
      },
      {
        id: 3,
        userId: 3,
        title: "Postpartum Mental Health Tips",
        content: "What are some ways to manage stress and anxiety after childbirth?",
        comments: [{ userId: 4, comment: "Journaling and light exercises really helped me!" }],
        img: '',
        likes: 7,
        retweets: 4,
      },
      {
        id: 4,
        userId: 5,
        title: "Morning Sickness Remedies",
        content: "How did you deal with morning sickness in your first trimester?",
        comments: [{ userId: 6, comment: "Ginger tea and small frequent meals worked wonders for me!" }],
        likes: 3,
        retweets: 2,
      }
    ]);
  }, []);

  const handlePostSubmit = () => {
    if (newPost.title && newPost.content) {
      const aiSuggestion = getAISuggestions(newPost.content);
      const newPostData = { 
        id: posts.length + 1, 
        userId: 1, 
        title: newPost.title, 
        content: newPost.content, 
        comments: aiSuggestion ? [{ userId: 0, comment: aiSuggestion }] : [], 
        likes: 0, 
        retweets: 0 
      };
      setPosts([newPostData, ...posts]);
      setNewPost({ title: '', content: '' });
    }
  };

  const handleLike = (postId) => {
    setPosts(posts.map(post => 
      post.id === postId ? { ...post, likes: post.likes + 1 } : post
    ));
  };

  const handleRetweet = (postId) => {
    setPosts(posts.map(post => 
      post.id === postId ? { ...post, retweets: post.retweets + 1 } : post
    ));
  };

  const handleComment = (postId) => {
    // Simple action to show how it could be expanded for a comment feature
    const commentText = prompt('Enter your comment');
    if (commentText) {
      setPosts(posts.map(post => 
        post.id === postId ? { 
          ...post, 
          comments: [...post.comments, { userId: 0, comment: commentText }] 
        } : post
      ));
    }
  };

  return (
    <div className={styles.container}>
      <h2 className={styles.header}>Community Feed</h2>
      <div className={styles.newPost}>
        <div className={styles.compose}>
          <input 
            type="text" 
            placeholder="What's happening?" 
            className={styles.input} 
            value={newPost.title} 
            onChange={(e) => setNewPost({ ...newPost, title: e.target.value })} 
          />
          <textarea 
            placeholder="Share your thoughts..." 
            className={styles.textarea} 
            value={newPost.content} 
            onChange={(e) => setNewPost({ ...newPost, content: e.target.value })} 
          />
          <button onClick={handlePostSubmit} className={styles.postButton}>Tweet</button>
        </div>
      </div>
      <div className={styles.posts}>
        {posts.map((post) => (
          <div key={post.id} className={styles.postCard}>
            <img src={newmage} alt="" />
            <div className={styles.postHeader}>
              <h3>{post.title}</h3>
            </div>
            <p>{post.content}</p>
            <div className={styles.actions}>
              <button onClick={() => handleLike(post.id)} className={styles.actionButton}>
                Like ({post.likes})
              </button>
              <button onClick={() => handleRetweet(post.id)} className={styles.actionButton}>
                Retweet ({post.retweets})
              </button>
              <button onClick={() => handleComment(post.id)} className={styles.actionButton}>
                Comment ({post.comments.length})
              </button>
            </div>
            <h4>Comments</h4>
            {post.comments.length > 0 ? (
              post.comments.map((comment, index) => <p key={index} className={styles.comment}>{comment.comment}</p>)
            ) : (
              <p className={styles.noComments}>No comments yet</p>
            )}
          </div>
        ))}
      </div>
      <button onClick={() => changePage("dashboard")} className={styles.backButton}>Back to Dashboard</button>
    </div>
  );
};

export default CommunityPage;
