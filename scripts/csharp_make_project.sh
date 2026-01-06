dotnet_version="$(dotnet --version)"
if [[ $dotnet_version == 1* ]]; then
  dotnet_version="${dotnet_version:0:4}"
else
  dotnet_version="${dotnet_version:0:3}"
fi

if [ "$#" -ne 1 ]; then
  echo "Please provide the project name."
  exit 1
fi

project_name=$1
if [ -d "$project_name" ]; then
  echo "The directory exists, please delete it first."
  exit 1
fi
dotnet new console --name ${project_name}
cd "${project_name}"

echo "{
  \"configurations\": {
    \"launch - netcoredbg\": {
      \"adapter\": \"netcoredbg\",
      \"filetypes\": [ \"cs\", \"fsharp\", \"vbnet\" ], // optional
      \"configuration\": {
        \"request\": \"launch\",
        \"program\": \"\${workspaceRoot}/bin/Debug/net${dotnet_version}/${project_name}.dll\",
        \"args\": [],
        \"stopAtEntry\": true,
        \"cwd\": \"\${workspaceRoot}\",
        \"env\": {}
      }
    }
  }
}" >> .vimspector.json
