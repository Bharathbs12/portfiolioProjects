select * 
from portfolioproject.dbo.CovidDeaths
where continent is not null
order by 3,4

--select * 
--from portfolioproject.dbo.CovidVaccinations
--order by 3,4

--select data that we are going to be using 

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
where continent is not null
order by 1,2


--Looking at Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from portfolioproject..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total Cases vs population 
--shows what percentage of population got covid

select location, date,population, total_cases, (total_cases/population)*100 as percentagepopulationInfection
from portfolioproject..CovidDeaths
--Where location like '%states%'
order by 1,2

--looking at countries with Highest Infection Rate compared to population

select location, population, max(total_cases) as HighestInfectioncount, max((total_cases/population))
*100 as percentagepopulationInfected
from portfolioproject..CovidDeaths
--Where location like '%states%'
group by location, population
order by percentagepopulationInfected desc

--showing countries with Highest death count per population

--LET'S BREAK THINGS DOWN BY CONTINENT


select continent,  max(cast(total_deaths as int)) as TotalDeathscount
from portfolioproject..CovidDeaths
--Where location like '%states%'
where continent is not null
group by continent
order by TotalDeathscount desc



--showing continents with the highest death count per population

select continent,  max(cast(total_deaths as int)) as TotalDeathscount
from portfolioproject..CovidDeaths
--Where location like '%states%'
where continent is not null
group by continent
order by TotalDeathscount desc


--GLOBAL NUMBERS

select  sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
From portfolioproject..CovidDeaths
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATIONS

-- USE CTE

with popvsvac(continent, location, date, population, new_vaccinations,Rollingpeoplevaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
 --(Rollingpeoplevaccinated/population)*100
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(Rollingpeoplevaccinated/population)*100
from popvsvac


--TEMP TABLE

drop table if exists #percentpopulationvaccinatied
create  Table #percentpopulationvaccinatied
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinatied
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
 --(Rollingpeoplevaccinated/population)*100
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *,(Rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinatied


--create view to store data for later visualizations

create view percentpopulationvaccinatied as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
 --(Rollingpeoplevaccinated/population)*100
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from percentpopulationvaccinatied