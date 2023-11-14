// pages/dashboard.js
'use client'
import { useRouter } from 'next/router';
import AddCourse from '../src/components/course/addCourse';
import AddShift from '../src/components/report/addshift';
import ShiftsReport from '../src/components/report/report';
import { shift } from '../types/shifts';
import { Course } from '../types/course';
import { Status } from '../types/status';

const Dashboard = () => {
  const router = useRouter();

  const handleAddCourse = () => {
    // Add logic to add a new course
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
      {/* Add logic to show either AddSelectCourseScreen or ReportScreen based on state
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
      /> */}
      <AddCourse />
      <AddShift 
      course={Course}
      status={Status.sa}
      />
      <ShiftsReport
      shift={shift}
      />
    </div>
  );
};

export default Dashboard;
