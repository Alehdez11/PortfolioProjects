SELECT * 
FROM Portafolio_1.coviddeaths
WHERE continent is not null;

## select Data 

SELECT Location,date,total_cases,new_cases,total_deaths,population
FROM Portafolio_1.coviddeaths
WHERE continent is not null
order by 1,2;

## Looking at total cases vrs total deaths 

SELECT Location,date,total_cases,total_deaths,population, (total_deaths/total_cases)*100 as Death_Porcentage
FROM Portafolio_1.coviddeaths
where location like '%costa rica%'
and continent is not null
order by 1,2;

## Looking at total cases vs Population
## shows what percentage of population got covid

SELECT Location,date,total_cases,population, (total_cases/population)*100 as PercentPopulationinfected
FROM Portafolio_1.coviddeaths
where location like '%costa rica%'
and continent is not null
order by 1,2;

##Looking at countries with highest infection rate compared to population 

SELECT Location,population,max(total_cases) as highest, max((total_cases/ population))*100 as percentagepopulationinfected
FROM Portafolio_1.coviddeaths
group by location, population
order by percentagepopulationinfected desc;

##showing countries with highest death count per population 

SELECT Location,max(total_deaths) as totaldeathcount
FROM Portafolio_1.coviddeaths
group by location
order by totaldeathcount desc;

## Continent ###

SELECT continent,max(total_deaths) as totaldeathcount
FROM Portafolio_1.coviddeaths
where continent is not null
group by continent
order by totaldeathcount desc;


## Global numbers 

SELECT Location,date,total_cases,total_deaths,population, (total_deaths/total_cases)*100 as Death_Porcentage
FROM Portafolio_1.coviddeaths
where location like '%costa rica%'
and continent is not null
order by 1,2;

SELECT SUM(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/ SUM(new_cases)*100 as Deathpercentage
FROM Portafolio_1.coviddeaths
where location like '%costa rica%'
and continent is not null
order by 1,2;

SELECT dea.continent,dea.location,dea.date,dea.population
FROM Portafolio_1.coviddeaths dea;

SELECT vac.new_vaccinations
FROM Portafolio_1.covidvaccinations vac;


--- looking at total population vs vaccionations 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date ) as rollingpeoplevacc
FROM Portafolio_1.coviddeaths dea
join Portafolio_1.covidvaccinations vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- Use CTE 
WITH PopvsVacc (Continent,location,date,population,new_vaccinations,rollingpeoplevacc)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date ) as rollingpeoplevacc
FROM Portafolio_1.coviddeaths dea
join Portafolio_1.covidvaccinations vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
select *, (rollingpeoplevacc/population)*100
from PopvsVacc

-- TEMP


Drop table if exist #PercentPopulationvaccinated 
Create table #PercentPopulationvaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rollingpeoplevacc numeric
)
insert into
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date ) as rollingpeoplevacc
FROM Portafolio_1.coviddeaths dea
join Portafolio_1.covidvaccinations vac
on  dea.location = vac.location
and dea.date = vac.date
-- where dea.continent is not null
-- order by 2,3
select *, (rollingpeoplevacc/population)*100
from PopvsVacc

--- create view to store data for later Viz

create view percentpopulationvaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date ) as rollingpeoplevacc
FROM Portafolio_1.coviddeaths dea
join Portafolio_1.covidvaccinations vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3



 







