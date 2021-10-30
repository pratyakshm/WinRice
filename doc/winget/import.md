# WinGet Import Command

Together with [`winget export`](https://docs.microsoft.com/en-us/windows/package-manager/winget/export), `winget import` can batch install apps from an exported JSON file.

Dependency: [`winget`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winget.md)

## Exporting App List to JSON Using `Winget Export` Command

To use `winget import`, you must use the `winget export` command first to export a JSON file consisting of apps currently installed on your device.

Use the following command to export list of apps to a JSON with file name `apps.json` in `D:`:  
`winget export -o D:\apps.json`

The partition letter, file location and file name can be changed according to user preference.

## Using `winget import` in WinRice

If configured during pre-execution environment, WinRice will ask user to select the exported JSON file using File Explorer picker UI.

If a **valid** JSON file is selected, WinRice will use `winget import` to batch install the apps.  
If an **invalid** JSON file is selected, `winget` will throw an error and WinRice will skip to the next job.  
If **no** JSON file is selected, WinRice will skip to the next job.

## Related Docs

- [winget docs](https://docs.microsoft.com/en-us/windows/package-manager/winget/)
- [winget export](https://docs.microsoft.com/en-us/windows/package-manager/winget/export)
- [winget import](https://docs.microsoft.com/en-us/windows/package-manager/winget/import)

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
