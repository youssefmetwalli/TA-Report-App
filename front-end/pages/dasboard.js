// pages/dashboard.js
import { useRouter } from 'next/router';
import AddSelectCourseScreen from '../src/components/AddSelectCourseScreen';
import ReportScreen from '../src/components/ReportScreen';

const Dashboard = () => {
  const router = useRouter();

  const handleAddCourse = () => {
    // Add logic to add a new course
  };

  const handleSelectCourse = () => {
    // Add logic to select an added course
  };

  const handleViewNotifications = () => {
    // Add logic to view notifications
  };

  const handleSendMessage = () => {
    // Add logic to send a message
  };

  const handleLogout = () => {
    // Add logout logic
    router.push('/');
  };

  return (
    <div>
      {/* Add logic to show either AddSelectCourseScreen or ReportScreen based on state */}
      <AddSelectCourseScreen
        onAddCourse={handleAddCourse}
        onSelectCourse={handleSelectCourse}
        onViewNotifications={handleViewNotifications}
        onSendMessage={handleSendMessage}
        onLogout={handleLogout}
      />
      <ReportScreen
        onInputWorkingHours={() => {}}
        onSpecifyWorkCategory={() => {}}
        onExportReport={() => {}}
        onSubmitReport={() => {}}
        onPrintReport={() => {}}
        onLogout={handleLogout}
      />
    </div>
  );
};

export default Dashboard;
