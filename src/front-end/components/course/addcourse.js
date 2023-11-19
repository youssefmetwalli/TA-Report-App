import { useState } from "react";
// import {useRouter} from 'next/router';
import { createCourse, Course } from "../../types/course";
import { useRouter } from 'next/router'


let new_course;
// const newCourse = (course, stat)=>{
//   course.status = stat
// }
const AddCourse = ({Status}) =>{

    const router = useRouter();

    // State to track the selected status
    const [selectedStatus, setSelectedStatus] = useState('');
    const handleStatusChange = (e) => {
        setSelectedStatus(e.target.value);
        // new_course.status = selectedStatus
    };

    // create a new report after submission
    const handleSubmit = (event) => {
      event.preventDefault();
      console.log('Course data:', courseData);
      new_course = {
        ...courseData
      };
      router.push('/reports');

    };

    //course data
    const [courseData, setCourseData] = useState(Course);
    // Function to handle input change
    const handleInputChange = (event) => {
      const { target } = event;
      const { name, value } = target;
        setCourseData({
        ...courseData,
        [name]: value,
        });
        console.log(courseData)
    };

    return (
        <section id="addCourse" className="overflow-hidden py-16 md:py-20 lg:py-28">
          <div className="container">
            <div className="-mx-4 flex flex-wrap">
              <div className="w-full px-4 lg:w-7/12 xl:w-8/12">
                <div
                  className="wow fadeInUp shadow-three dark:bg-gray-dark mb-12 rounded-sm bg-white px-8 py-11 sm:p-[55px] lg:mb-5 lg:px-8 xl:p-[55px]"
                  data-wow-delay=".15s
                  "
                >
                  <h2 className="mb-3 text-2xl font-bold text-black dark:text-white sm:text-3xl lg:text-2xl xl:text-3xl">
                    Creating a new report
                  </h2>
                  <p className="mb-12 text-base font-medium text-body-color">
                    If you want to edit a report that you already created check the <strong>reports</strong> page.
                  </p>
                  <form onSubmit={handleSubmit}>
                    <div className="-mx-4 flex flex-wrap">
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="name"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Course Name:
                          </label>
                          <input
                            type="text"
                            id="course-name"
                            name="name"
                            // value={courseData.name}
                            onChange={handleInputChange}
                            placeholder="Enter the course name"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="name"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Course ID:
                          </label>
                          <input
                            type="text"
                            id="course-id"
                            name="id"
                            // value={courseData.id}
                            onChange={handleInputChange}
                            placeholder="Enter the course ID"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="name"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Course Maximum Hours
                          </label>
                          <input
                            type="text"
                            id="max-hours"
                            name="max_hours"
                            // value={courseData.max_hours}
                            onChange={handleInputChange}
                            placeholder="Enter the course max hours"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="name"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Instructor Name
                          </label>
                          <input
                            type="name"
                            id="course-instructor"
                            name="instructor"
                            // value={courseData.instructor}
                            onChange={handleInputChange}
                            placeholder="Enter the instructor name"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4">
                        <div className="mb-8">
                          <label
                            htmlFor="TASA"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Select TA/SA:
                          </label>
                          <select
                            id="status-dropdown"
                            name="selectedStatus"
                            // value={selectedStatus}
                            onChange={handleStatusChange}
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full resize-none rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          >
                            <option value="">Select...</option>
                            <option value={Status.sa}>{Status.sa}</option>
                            <option value={Status.ta}>{Status.ta}</option>
                          </select>
                        </div>
                      </div>
                      <div className="w-full px-4">
                        <button  type="submit" className="shadow-submit dark:shadow-submit-dark rounded-sm bg-primary px-9 py-4 text-base font-medium text-white duration-300 hover:bg-primary/90">
                           Create Report
                        </button>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </section>
      );
}

export default AddCourse;

export let added_course = new_course;