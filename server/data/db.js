import Sequelize from 'sequelize'

const db = new Sequelize('vh_jobs', 'root', 'administrator', {
	dialect: 'sqlite',
	storage: 'data/db/development.db.sqlite',
	operatorsAliases: false
});

const Company = db.define('Company', {
	id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
	name: { type: Sequelize.STRING },
	description: { type: Sequelize.TEXT },
	location: { type: Sequelize.STRING },
	website: { type: Sequelize.STRING }
});

const Job = db.define('Job', {
	id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
	title: { type: Sequelize.STRING },
	position: { type: Sequelize.STRING },
	location: { type: Sequelize.STRING },
	slot: { type: Sequelize.INTEGER },
	deadline: { type: Sequelize.STRING },
	type: { type: Sequelize.STRING },
	salary: { type: Sequelize.STRING }
});

Company.hasMany(Job);
Job.belongsTo(Company);

// Company.sync({force: true});
// Job.sync({force: true});
	
export { Company, Job }

