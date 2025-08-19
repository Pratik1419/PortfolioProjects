Select *
From [Portfoilio Projects]..CovidDeaths
Where continent is  not null
order by 3,4


--Select *
--From [Portfoilio Projects]..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From [Portfoilio Projects]..CovidDeaths
order by 1,2

-- Looking at total Cases vs Total Deaths
-- Shows how many death will be in your country.
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfoilio Projects]..CovidDeaths
Where location like '%india%'
order by 1,2



-- Looking at total Cases vs Population
-- Showes what percentage of population got Covid
Select location, date, population, total_cases, (total_deaths/population)*100 as PercentPopulationInfected
From [Portfoilio Projects]..CovidDeaths
--Where location like '%india%'
Where continent is  not null
order by 1,2


-- Lokking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/population))*100 as PercentPopulationInfected
From [Portfoilio Projects]..CovidDeaths
--Where location like '%india%'
Group by location, population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population.

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfoilio Projects]..CovidDeaths
--Where location like '%india%'
Group by location
order by TotalDeathCount desc

-- BREAK THINGS DOWN BY CONTINENT


--  Showing contintents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfoilio Projects]..CovidDeaths
--Where location like '%india%'
Where continent is  not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [Portfoilio Projects]..CovidDeaths
--Where location like '%india%'
Where continent is  not null
order by 1,2

-- Looking at Total Population vs Vaccinations in a cte file
with PopvsVac (continent, location, date, population, new_vaccinations,People_Vaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as People_Vaccinated
from [Portfoilio Projects]..CovidDeaths dea
join [Portfoilio Projects]..CovidDeaths vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (People_Vaccinated/population) * 100 as People_Vaccinated_Percent
from PopvsVac

-- Creating View Table
Create View People_Vaccinated_Percent as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as People_Vaccinated
from [Portfoilio Projects]..CovidDeaths dea
join [Portfoilio Projects]..CovidDeaths vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3