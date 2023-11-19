// pages/dashboard.js
// import AddShift from '../src/components/report/addshift';
import ShiftsReport from '../components/report/report';
import { shift } from '../types/shifts';
import { Course } from '../types/course';
import { Status } from '../types/status';
import AddCourse from '../components/course/addcourse'


const Dashboard = () => {

  return (
    <div>
      <AddCourse 
        Status={Status}
      />
      <ShiftsReport
      shift={shift}
      w_course={Course}
      status={Status.sa}
      />
    </div>
  );
};

export default Dashboard;
