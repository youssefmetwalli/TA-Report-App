const { buildSchema } = require('graphql');

const schema = buildSchema(`
  type AssignedCourse {
    id: String
    studentId: String
    courseId: String
    profId: String
    status: Int
    maxHours: Int
  }

  type Query {
    getAssignedCourses: [AssignedCourse]
  }

  type Mutation {
    assignCourse(studentId: String, courseId: String, profId: String, status: Int, maxHours: Int): AssignedCourse
  }
`);

module.exports = schema;
