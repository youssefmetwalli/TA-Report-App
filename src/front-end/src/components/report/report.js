
// src/components/ShiftsReport.js
import React from 'react';

const ShiftsReport = ({ shift }) => {
  return (
    <section id="shiftsReport" className="overflow-hidden py-16 md:py-20 lg:py-28">
      <div className="container">
        <div className="-mx-4">
          <div
            className="wow fadeInUp shadow-three dark:bg-gray-dark mb-12 rounded-sm bg-white px-8 py-11 sm:p-[55px] lg:mb-5 lg:px-8 xl:p-[55px]"
            data-wow-delay=".15s"
          >
            <h2 className="mb-3 text-2xl font-bold text-black dark:text-white sm:text-3xl lg:text-2xl xl:text-3xl">
              Shifts Report
            </h2>
            <div className="overflow-x-auto">
              <table className="min-w-full bg-white border border-gray-300 shadow-md rounded-md overflow-hidden">
                <thead className="bg-primary text-white">
                  <tr>
                    <th className="py-2 px-4 text-left">Date</th>
                    <th className="py-2 px-4 text-left">Start Time</th>
                    <th className="py-2 px-4 text-left">End Time</th>
                    <th className="py-2 px-4 text-left">Break Time</th>
                    <th className="py-2 px-4 text-left">Shift Hours</th>
                  </tr>
                </thead>
                <tbody>
                  {/* {shifts.map((shift) => ( */}
                    <tr key={shift.id} className="border-t border-gray-300">
                      <td className="py-2 px-4">{shift.date_time}</td>
                      <td className="py-2 px-4">{shift.start_time}</td>
                      <td className="py-2 px-4">{shift.end_time}</td>
                      <td className="py-2 px-4">{shift.break_time} minutes</td>
                      <td className="py-2 px-4">{shift.shift_hours} hours</td>
                    </tr>
                  {/* ))} */}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ShiftsReport;
