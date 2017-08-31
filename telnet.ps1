Configuration telnet
    {node localhost 
  
      {
        windowsfeature WDS
        {
          Name = 'wds'
          Ensure ='present'
          Includeallsubfeature = $true
        }
     }
  }