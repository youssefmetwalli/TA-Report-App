// components/AddSelectCourseScreen.js
const AddSelectCourseScreen = ({ onAddCourse, onSelectCourse, onViewNotifications, onSendMessage, onLogout }) => {
    return (
      <div>
        <h1>Add/Select Course Screen</h1>
        {/* Implement buttons and functionality here */}
        <button onClick={onAddCourse}>Add Course</button>
        <button onClick={onSelectCourse}>Select Course</button>
        <button onClick={onViewNotifications}>View Notifications</button>
        <button onClick={onSendMessage}>Send Message</button>
        <button onClick={onLogout}>Logout</button>
      </div>
    );
  };
  
  export default AddSelectCourseScreen;
  