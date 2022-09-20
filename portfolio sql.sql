
Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations$
where continent is not null
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

-- looking at Total Cases vs Total Deaths
 
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Deathapercentage
From PortfolioProject..CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2


--looking at total_cases vs population

Select location, date, total_cases, population ,(total_deaths/population)*100 as PercentPopulationinfected
From PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

-- looking at countries with highest infection rate compared to population

Select location,population, max(total_cases) as Highestinfectedcount, max((total_deaths/population))*100 as PercentPopulationinfected
From Portfolioproject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location, population
order by PercentPopulationinfected desc


-- showing countries with highest death count per population



Select location, max(cast(total_deaths as int)) as totaldeathcount
From Portfolioproject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location, population
order by totaldeathcount desc


--showing things by continent

Select continent, max(cast(total_deaths as int)) as totaldeathcount
From Portfolioproject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc


--showing continents with highest death count per population
Select continent, max(cast(total_deaths as int)) as totaldeathcount
From Portfolioproject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc


-- Global numbers by date
Select date, sum(new_cases)as total_cases ,sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int)) / sum(new_cases)*100  as Deathapercentage
From PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2



-- Total Global numbers 
Select  sum(new_cases)as total_cases ,sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int)) / sum(new_cases)*100  as Deathapercentage
From PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

-- looking at Total Population vs Vaccinatons 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated)*100
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


 --CTE

 With popvsvac (continent, location, date, population,new_vaccinations, rollingpeoplevaccinated)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated)*100
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
select *, (rollingpeoplevaccinated/population)*100
from popvsvac


--TEMP TABLE

create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated)*100
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3


select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated

--creating view to store date for later visualization

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated)*100
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated
