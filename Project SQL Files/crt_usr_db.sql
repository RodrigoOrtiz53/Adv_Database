/*
	Group #5
	Members: Mitchell Alvarado, Sean Fontes, Rodrigo Ortiz
	Creates the user and database for our project.
*/

CREATE USER rortiz SUPERUSER PASSWORD 'schwans';

CREATE DATABASE rortiz with OWNER = rortiz;
