import ShiftsReport from '../../components/report/report';
import { shift } from '../../types/shifts';
import { Course } from '../../types/course';
import { Status } from '../../types/status';
import AddCourse from '../../components/course/addcourse'


const Dashboard = () => {

  return (
    <div id="addCourse" className="overflow-hidden py-16 md:py-20 lg:py-28">
    <div className="container text-center">
      <div className="-mx-6 text-center">
        <h1 className='py-5 px-10'><strong>Your Reports:</strong></h1>
      <ul>
        <li><>Link to first report</></li>
        <li><>Link to second report</></li>
        <li><>Link to third report</></li>
        <li><>Link to fourth report</></li>
      </ul>
    </div>
    </div> </div> 
  );
};

export default Dashboard;
