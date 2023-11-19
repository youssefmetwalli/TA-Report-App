import 'server-only'

import ShiftsReport from '../../components/report/report';
import { shift } from '../../types/shifts';
import { Course } from '../../types/course';
import { Status } from '../../types/status'

const courses = ()=>{
    return (
        <ShiftsReport
        shift={shift}
        w_course={Course}
        status={Status.sa}
        />
    )

}

export default courses;