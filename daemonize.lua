local posix=require"posix"
local M={}

function M.daemonize(name, path, stdout, stderr, stdin)
	local path=path or "/"
	local stdout=stdout or "/dev/null"
	local stdin=stdin or "/dev/null"
	local stderr=stderr or "/dev/null"
	local pid=assert(posix.fork())
	if pid > 0 then
		os.exit(0)
	end
	assert(posix.setpid("sid"))
	assert(posix.signal(posix.SIGCHLD,posix.SIG_IGN))
	assert(posix.signal(posix.SIGHUP,posix.SIG_IGN))
	pid=assert(posix.fork())
	if pid > 0 then
		os.exit(0)
	end
	posix.umask(0)
	posix.chdir(path)
	for i =1,posix.sysconf("OPEN_MAX") do
		posix.close(i)
	end
	io.stdin=io.open(stdin,"r")
	io.stdout=io.open(stdout,"w+")
	io.stderr=io.open(stderr,"w+")
	return 0
end
--[[ daemonize c code:
int
daemonize(char* name, char* path, char* outfile, char* errfile, char* infile )
{
    if(!path) { path="/"; }
    if(!name) { name="medaemon"; }
    if(!infile) { infile="/dev/null"; }
    if(!outfile) { outfile="/dev/null"; }
    if(!errfile) { errfile="/dev/null"; }
    //printf("%s %s %s %s\n",name,path,outfile,infile);
    pid_t child;
    //fork, detach from process group leader
    if( (child=fork())<0 ) { //failed fork
        fprintf(stderr,"error: failed fork\n");
        exit(EXIT_FAILURE);
    }
    if (child>0) { //parent
        exit(EXIT_SUCCESS);
    }
    if( setsid()<0 ) { //failed to become session leader
        fprintf(stderr,"error: failed setsid\n");
        exit(EXIT_FAILURE);
    }

    //catch/ignore signals
    signal(SIGCHLD,SIG_IGN);
    signal(SIGHUP,SIG_IGN);

    //fork second time
    if ( (child=fork())<0) { //failed fork
        fprintf(stderr,"error: failed fork\n");
        exit(EXIT_FAILURE);
    }
    if( child>0 ) { //parent
        exit(EXIT_SUCCESS);
    }

    //new file permissions
    umask(0);
    //change to path directory
    chdir(path);

    //Close all open file descriptors
    int fd;
    for( fd=sysconf(_SC_OPEN_MAX); fd>0; --fd )
    {
        close(fd);
    }

    //reopen stdin, stdout, stderr
    stdin=fopen(infile,"r");   //fd=0
    stdout=fopen(outfile,"w+");  //fd=1
    stderr=fopen(errfile,"w+");  //fd=2

    //open syslog
    openlog(name,LOG_PID,LOG_DAEMON);
    return(0);
}
]]

return M
