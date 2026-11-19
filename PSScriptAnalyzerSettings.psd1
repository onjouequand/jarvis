@{
    # Réglages de PSScriptAnalyzer pour src/jarvis-checkup.ps1 (lus par tools/check.ps1).
    Severity     = @('Error', 'Warning')
    ExcludeRules = @(
        # Outil à interface console : Write-Host est le moyen d'affichage voulu.
        'PSAvoidUsingWriteHost',
        # Compté et plafonné par tools/check.ps1 (le nombre ne peut que baisser).
        'PSAvoidUsingEmptyCatchBlock',
        # Noms internes historiques (Cut, Type-Line, Pause-Ms...) : aucune commande exportée.
        'PSUseApprovedVerbs',
        'PSUseSingularNouns',
        # Mode ASCII : Write-Host est redéfini exprès pour convertir les caractères de dessin.
        'PSAvoidOverwritingBuiltInCmdlets',
        # 1.1.1.1 est l'adresse publique fixe qui sert à tester l'accès Internet.
        'PSAvoidUsingComputerNameHardcoded',
        # Fonctions internes d'un script interactif : chaque action est déjà confirmée par une question.
        'PSUseShouldProcessForStateChangingFunctions'
    )
}
