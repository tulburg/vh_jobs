import express from 'express';
import { apolloServer } from 'graphql-tools';
import jwt from 'jsonwebtoken';
// -----
import { schema, resolvers } from './data/schema+resolver'

var app = express();
var port = 8000;
process.env.JWT_KEY = "MFbWMxyWXbXyGDjVw9WCG3Q7";

app.use("/auth", function(req, res) {
	var token = jwt.sign({ access: 1010 }, process.env.JWT_KEY, 
		{ expiresIn: Date.now() + (30 * 24 * 60 * 60 * 1000)});
	res.send({ data : { token: token, roles : 0 }});
});

app.use("/", new apolloServer((req, res, next) =>{
	try {
		// e
		if(req.headers.authorization) {
			var header = req.headers.authorization.split(" ");
			if(header[0] == "Bearer") {
				var token = header[1];
				jwt.verify(token, process.env.JWT_KEY);
				return { graphiql: true, schema, pretty: true, resolvers }
			}else {
				throw { message: "Invalid authorization scheme" };
			}
		}else {
			throw { message: "Authorization required!" };
		}
	}catch(e) {
		throw e;
		throw { message: "Authorization Failed!"};
	}
}));


app.listen(port, function(err) {
	if(err) { console.log(err); }
	else { console.log(`Listening on port ${port}`); }
});