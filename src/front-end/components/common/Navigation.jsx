/**
Renders a navigation component with a sticky header, containing a logo and a link to take a quiz.
@component
@returns {JSX.Element} The rendered navigation component.
*/

import Link from 'next/link'
import { Container } from './Container'
import Image from 'next/image'
import { TbArrowBigRightFilled } from 'react-icons/tb'

export const Navigation = () => {
  return (
    <div className="sticky top-0 backdrop-blur-xl bg-[rgba(212,222,237,0.8)] border-b border-slate-800 z-50">
      <Container className="flex justify-between py-5" as="nav">
        <Link href="/dashboard">
          <Image src="/best_panther_icon.png" alt="Pantha" width={50} height={10} />
        </Link>
        <Link
          href="/courses"
          className="flex items-center justify-center gap-1 px-5 font-semibold text-black transition-colors bg-blue-200 rounded-md duration-600 hover:bg-blue-600"
        >
          <p className="text-lg" />
          New Report
        </Link>
        <Link
          href="/dashboard"
          className="flex items-center justify-center gap-1 px-5 font-semibold text-black transition-colors bg-blue-200 rounded-md duration-600 hover:bg-blue-600"
        >
          <p className="text-lg" />
          My Reports
        </Link>
      </Container>
    </div>
  )
}
