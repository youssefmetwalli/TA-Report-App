### Run the back-end

    cd src/back-end
    npm install mysql express
    npm install
    run the code: `npm run dev`

## Technologies

1. mysql

2. nodejs

3. expressjs

## API Routes

### login
#### authenticate
         - body: id, password
         - method: post
         - url: uri/login
### Report:
#### create
         - first, add a course [calling add course api]:
             body: {
      "student_id":"student789",
       "prof_id":"prof_id",
       "course_id" : "SE01",
        "status" : 0,
         "max_hours": 30,
          "course_name" : "course_name;",
           "quarter": "4",
            "semester" : "2"
}

        - 

#### get reports

- needs: course name, academic year, month
- first, get courses by Body: "studen_id":
     
         RETURNS: {
     ` "success": true,
      "result": [
        {
          "ID": 8,
          "student_id": "student789",
          "course_id": "SE04",
          "prof_id": "faculty123",
          "status": 0,
          "max_hours": 50
        },
          "ID": 19,
          "student_id": "student789",
          "course_id": "SE01",
          "prof_id": "faculty123",
          "status": 0,
          "max_hours": 50
        }
      ],
      "message": "Successfully got all the course_id assigned"
    } `
    
 - use the "result.ID" to get all the reports by Body: "result.ID"
    
        RETURNS: {
      ` "success": true,
      "result": [
        {
          "report_id": 9,
          "assigned_course_id": 19,
          "report_date": "2023-12-15T15:00:00.000Z",
          "report_description": "new report"
        },
        {
          "report_id": 10,
          "assigned_course_id": 19,
          "report_date": "2022-03-10T15:00:00.000Z",
          "report_description": "newie"
        }
      ],
      "message": "Successfully got the report's data of the assigned_course_id"
    }`
   

5. Shifts:
