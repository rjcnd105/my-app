import { View } from '@shared/ui/Templates/View'
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/_pathlessLayout/_nested-layout/route-a')(
  {
    component: LayoutAComponent,
  },
)

function LayoutAComponent() {
  return <View transitionName="main">I'm A!</View>
}
