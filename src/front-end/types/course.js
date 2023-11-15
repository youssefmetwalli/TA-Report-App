// courses type
export const createCourse = (id, name, instructor, max_hours) =>
{
    return{
        id,
        name,
        instructor,
        max_hours
    };
}
export const Course = createCourse('CN01','Course Name',"Instructor Name", 25);