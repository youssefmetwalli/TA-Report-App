// import './globals.css'
import { Inter } from 'next/font/google'
import { Navigation } from '../components/common/Navigation'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Pantha',
  description: 'TA Report System App by Pikachu',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Navigation />
        {children}
      </body>
    </html>
  )
}
