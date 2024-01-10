// dto/usersDto.js
class UsersDto {
    constructor(id, name, password, role, status) {
      this.id = id;
      this.name = name;
      this.password = password;
      this.role = role;
      this.status = status; //JP:0 or Int:1
    }
  }
  
  module.exports = UsersDto;
  