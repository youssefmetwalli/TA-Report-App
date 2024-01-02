const {
    userExists,
    loginUser
} = require ('../services/usersService');

const loginRoute = async function (req, res){
    try{
        const user_id = req.body.id;
        const password = req.body.password;

        const loggingIn = await loginUser(user_id, password);
        if(loggingIn.success){
            res.json(loggingIn);
        }
        else{
            res.status(401).json(loggingIn); //wrong credentials
        }
    }
    catch(error){
        console.log("internal server error");
        res.status(500).json(error);
    }
}

module.exports ={
    loginRoute
}