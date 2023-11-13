import React from 'react';
import Image from 'next/image';
import SearchBar from './searchbar';
import PhotoData from '../data.json';

const NavBar = (props) => {
  return (
    <nav>
      <div className="fixed top-0 z-0 flex left-20 items-center w-full bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800/30 dark:from-inherit lg:static lg:w-auto lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800/30">
        <a href="/">
          <Image src="/ReLi.png" alt="Logo" width={200} height={100} />
        </a>
        <SearchBar data={PhotoData} />
        <span className="flex mr-6 font-mono font-bold text-4xl">{props.pageName}</span>
        <div className="flex-grow"></div>
      </div>
    </nav>
  );
};

export default NavBar;


