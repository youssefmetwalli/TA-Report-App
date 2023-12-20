import 'server-only'
import  AddCourse from "../../components/course/addcourse";
import {Status} from '../../types/status'

const courses = ()=>{
    return (<AddCourse
        Status={Status}
    />)
}

export default courses;