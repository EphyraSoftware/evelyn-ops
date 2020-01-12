def helmVersionPM = new ProcManager('helm version')
defaultProcExecutor(helmVersionPM)

def helmRepoAddPM = new ProcManager('helm repo add elastic https://helm.elastic.co')
defaultProcExecutor(helmRepoAddPM)

def helmInstallPM = new ProcManager('helm install elasticsearch elastic/elasticsearch --namespace evelyn-platform -f values.yaml')
defaultProcExecutor(helmInstallPM)

//def helmUpgradePM = new ProcManager('helm upgrade elasticsearch elastic/elasticsearch --namespace evelyn-platform -f values.yaml')
//defaultProcExecutor(helmUpgradePM)

void defaultProcExecutor(ProcManager procManager) {
    def exitCode = procManager.run()
    if (exitCode != 0) {
        println procManager.getErrorOutput()
        System.exit(1)
    }

    println procManager.getStandardOutput()
}

class ProcManager {
    private StringBuilder sout = new StringBuilder();
    private StringBuilder serr = new StringBuilder();
    private String cmd

    ProcManager(String cmd) {
        this.cmd = cmd
    }

    int run() {
        def proc = this.cmd.execute()
        proc.consumeProcessOutput(this.sout, this.serr)
        proc.waitForOrKill(30000)

        return proc.exitValue()
    }

    StringBuilder getStandardOutput() {
        return this.sout
    }

    StringBuilder getErrorOutput() {
        return this.serr
    }
}
