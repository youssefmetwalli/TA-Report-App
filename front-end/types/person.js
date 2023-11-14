import { Status } from "./status";

//actor type
export const createPerson = (id, name, status) =>{
    return{
        id,
        name,
        status,
        displayInfo() {
            console.log(`ID: ${this.id}, Name: ${this.name}, Status: ${this.status}`);
          },
    }
  };

export const Person = createPerson('s1282007', 'Messi', Status.sa)
Person.displayInfo()

//interface
// class Person {
//     constructor(id, name, status) {
//       this.id = id;
//       this.name = name;
//       this.status = status;
//     }
  
//     displayInfo() {
//       console.log(`ID: ${this.id}, Name: ${this.name}, Status: ${this.status}`);
//     }
//   }
  
//   const personInstance = new Person('s1282007', 'Messi', 'Active');
//   personInstance.displayInfo();
  