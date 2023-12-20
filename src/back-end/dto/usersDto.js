// dto/usersDto.js
class UsersDto {
    constructor(id, name, password, role, status) {
      this.id = id;
      this.name = name;
      this.password = password;
      this.role = role;
      this.status = status;
    }
  }
  
  module.exports = UsersDto;
  