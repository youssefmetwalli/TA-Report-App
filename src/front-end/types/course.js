// courses type
export const createCourse = (id, name, instructor) =>
{
    return{
        id,
        name,
        instructor
    };
}
export const Course = createCourse('CN01','Course Name',"Instructor Name");