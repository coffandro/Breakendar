export enum Weekday {
    Monday = "Monday",
    Tuesday = "Tuesday",
    Wednesday = "Wednesday",
    Thursday = "Thursday",
    Friday = "Friday",
    Saturday = "Saturday",
    Sunday = "Sunday"
}

export enum Month {
    January = "January",
    February = "February",
    March = "March",
    April = "April",
    May = "May",
    June = "June",
    July = "July",
    August = "August",
    September = "September",
    October = "October",
    November = "November",
    December = "December"
}

export type Day = {
    name: string;
    date: Date;
    enabled: boolean;
}

export const GetMonth = (monthNum: number): Month => {
    monthNum = ((monthNum % 12) + 12) % 12;

    return Month[Object.keys(Month)[monthNum] as keyof typeof Month];
}

export const GetRelativeMonth = (current: Month, dir: number): Month => {
    let month: Month = GetMonth(
        Object.keys(Month).indexOf(current) + dir
    );

    return month;
}

export const GetDays = (month: Month, year: number) : Day[] => {
    let days: Day[] = [];

    // Map Month enum to numeric index (0-based for JS Date)
    const monthIndex = Object.values(Month).indexOf(month);
    if (monthIndex === -1) return days;

    // Get number of days in the month
    const numDays = new Date(year, monthIndex + 1, 0).getDate();

    for (let i = 1; i <= numDays; i++) {
        const date = new Date(year, monthIndex, i);
        days.push({
            name: i.toString(),
            date,
            enabled: true // defaulting to true; can customize if needed
        });
    }

    return days;
}