import { Company, Job } from './db';

const schema = `
	type Query {
		companies(start: Int, limit: Int): [Company]
		company(id: Int): Company
		jobs(start: Int, limit: Int): [Job]
		job(id: Int): Job
	}
	type Company {
		id: Int
		name: String
		description: String
		location: String
		website: String
	}
	type Job {
		id: Int
		title: String
		position: String
		location: String
		slot: Int
		deadline: String
		type: String
		salary: String
		company: Company
	}
	type Mutation {
		createCompany(name: String, description: String, location: String, website: String): Boolean
		createJob(title: String, position: String, location: String, slot: Int, deadline: String, type: String, salary: String, companyId: Int): Boolean
		filterJobs(filter: String, value: String) : [Job]
	}
	schema {
		query: Query
		mutation: Mutation
	}
`;

const resolvers = {
	Query: {
		companies(_, args) { 
			return Company.findAll({
				offset: args.start,
				limit: args.limit,
				order: [["createdAt", "DESC"]]
			});
		},
		company(_, args) {
			return Company.findOne({
				companyid: args.id
			});
		},
		jobs(_, args) {
			return Job.findAll({
				offset: args.start,
				limit: args.limit,
				order: [["id", "DESC"]]
			});
		},
		job(_, args) {
			return Job.findOne({
				jobid: args.id
			});
		}
	},
	Mutation: {
		createCompany: (root, {name, description, location, website}, context) => {
			if(isEmpty([name, description, location, website])) {
				throw "A required field is empty!";
			}else {
				return Company.findOne({ where: { name: name }}).then(company => {
					if(company != null) {
						return false; 
					}
					return Company.create({name: name, description: description, location: location, website: website});
				});
			}
		},
		createJob: (root, {title, position, location, slot, deadline, type, salary, companyId}, context) => {
			if(isEmpty([title, position, location, slot, deadline, type, salary, companyId])) {
				throw "A required field is empty!";
			}else {
				return Job.findOne({ where: { title: title }}).then(job => {
					if(job != null) {
						return false;
					}
					return Job.create({title: title, position: position, location: location, slot: slot, deadline: deadline, type: type, salary: salary, companyId: companyId});
				});
			}
		},
		filterJobs: (root, {filter, value}, context) => {
			if(isEmpty([filter, value])) {
				throw "Filter cannot be empty!";
			}else {
				if(filter == "location") return Job.findAll({where: {location: value}});
				if(filter == "company") {
					return Company.findOne({where: {name: value}}).then(company => {
						return Job.findAll({ where: { companyId: company.id } });
					});
				}
				if(filter == "position") return Job.findAll({where: {position: value}});
			}
		}
	},
	Job: {
		company(root) { 
			return root.getCompany(); 
		}
	}
}

function isEmpty(array) {
	for(var i=0;i<array.length;i++){
		var input = array[i];
		if(input === null || typeof input === 'undefined' || isNaN(input) && !input.length) {
			return true;
		}
	}
	return false;
}

export { schema, resolvers }