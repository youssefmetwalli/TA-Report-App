// courses type
export class createCourse {
    constructor(id, name, instructor, max_hours) {
        this.id = id;
        this.name = name;
        this.instructor = instructor;
        this.max_hours = max_hours;
    }
}
export const Course = new createCourse('CN01','Course Name',"Instructor Name", 25);