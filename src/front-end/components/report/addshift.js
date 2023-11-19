"use client"

import {createShift, shift} from "../../types/shifts";
import { useState } from "react";

// let new_shift;
const AddShift = ({course, status}) =>{
    //course data
    const [shiftData, setShiftData] = useState(shift);

    // Function to handle input change
    const handleInputChange = (e) => {
        setShiftData({
        ...shiftData,
        [e.target.name]: e.target.value,
        });
        console.log("shiftData")
        console.log(shiftData)
    };

     // create a new report after submission
     const handleSubmit = (event) => {
      event.preventDefault();
      console.log('Shift data:', shiftData);
      const new_shift = new createShift(shiftData.date_time, shiftData.start_time, shiftData.end_time, shiftData.break_time)
      console.error(new_shift)

    };
return(
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
                    {course.name} Report
                  </h2>
                  <p className="mb-12 text-base font-medium text-body-color">
                    {status}
                  </p>
                  <form onSubmit={handleSubmit}>
                    <div className="-mx-4 flex flex-wrap">
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="date"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Date:
                          </label>
                          <input
                            type="date"
                            id="date"
                            name="date_time"
                            // value={shiftData.date_time}
                            onChange={handleInputChange}
                            placeholder="Enter the shift date"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="start"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Start Time:
                          </label>
                          <input
                            type="time"
                            id="start-time"
                            name="start_time"
                            // value={shiftData.start_time}
                            onChange={handleInputChange}
                            placeholder="Enter the Start Time"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="break"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            Break Time:
                          </label>
                          <input
                            type="time"
                            id="break-time"
                            name="break_time"
                            // value={shiftData.break_time}
                            onChange={handleInputChange}
                            placeholder="Enter the Break Time"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4 md:w-1/2">
                        <div className="mb-8">
                          <label
                            htmlFor="end"
                            className="mb-3 block text-sm font-medium text-dark dark:text-white"
                          >
                            End Time:
                          </label>
                          <input
                            type="time"
                            id="end-time"
                            name="end_time"
                            // value={shiftData.end_time}
                            onChange={handleInputChange}
                            placeholder="Enter the Start Time"
                            className="border-stroke dark:text-body-color-dark dark:shadow-two w-full rounded-sm border bg-[#f8f8f8] px-6 py-3 text-base text-body-color outline-none focus:border-primary dark:border-transparent dark:bg-[#2C303B] dark:focus:border-primary dark:focus:shadow-none"
                          />
                        </div>
                      </div>
                      <div className="w-full px-4">
                        <button  type="submit" className="shadow-submit dark:shadow-submit-dark rounded-sm bg-primary px-3 py-4 text-base font-medium text-white duration-300 hover:bg-primary/90">
                          Add Shift
                        </button>
                      </div>
                    </div>
                  </form>
                </div>
             </div>
            </div>
         </div>
     </section>
)
}

export default AddShift;